/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#include "testcasereport.h"

#include <QDateTime>

#include "io/path.h"
#include "log.h"

using namespace mu::autobot;

inline QTextStream& operator<<(QTextStream& s, const std::string& v)
{
    s << v.c_str();
    return s;
}

mu::Ret TestCaseReport::beginReport(const TestCase& testCase)
{
    io::path reportsPath = configuration()->reportsPath();
    Ret ret = fileSystem()->makePath(reportsPath);
    if (!ret) {
        return ret;
    }

    IF_ASSERT_FAILED(!m_file.isOpen()) {
        m_file.close();
    }

    QString tcname = testCase.name();
    QDateTime now = QDateTime::currentDateTime();
    QString reportPath = reportsPath.toQString()
                         + "/" + tcname
                         + "_" + now.toString("yyyyMMddhhmm")
                         + ".txt";

    m_file.setFileName(reportPath);
    if (!m_file.open(QIODevice::WriteOnly)) {
        return make_ret(Ret::Code::UnknownError);
    }

    m_stream.setDevice(&m_file);

    m_stream << "Test: " << tcname << Qt::endl;
    m_stream << "date: " << now.toString("yyyy.MM.dd hh:mm") << Qt::endl;
    m_stream << "steps: ";

    Steps steps = testCase.steps();
    int count = steps.count();
    for (int i = 0; i < count; ++i) {
        m_stream << steps.step(i).name();
        if (i < (count - 1)) {
            m_stream << " -> ";
        }
    }
    m_stream << Qt::endl;
    m_stream << Qt::endl;

    m_opened = true;
    return make_ret(Ret::Code::Ok);
}

void TestCaseReport::endReport(bool aborted)
{
    if (!m_opened) {
        return;
    }

    if (aborted) {
        m_stream << "Test case aborted!" << Qt::endl;
    }

    m_stream.flush();
    m_file.close();
}

void TestCaseReport::beginStep(const QString& name)
{
    if (!m_opened) {
        return;
    }
    m_stream << "  begin step: " << name << Qt::endl;
    m_stream.flush();
}

void TestCaseReport::endStep(const QString& name)
{
    if (!m_opened) {
        return;
    }

    m_stream << "  end step: " << name << Qt::endl;
}