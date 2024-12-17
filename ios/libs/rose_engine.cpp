/*
    Stockfish for flutter is an integration of Stockfish chess engine for Flutter framework.
    Copyright (C) 2022  Laurent Bernabe

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include "rose_engine.h"

#include <iostream>
#include <stdio.h>
#include <cstring>
#include <unistd.h>

// 2


// https://jineshkj.wordpress.com/2006/12/22/how-to-capture-stdin-stdout-and-stderr-of-child-program/
#define NUM_PIPES 2
#define PARENT_WRITE_PIPE 0
#define PARENT_READ_PIPE 1
#define READ_FD 0
#define WRITE_FD 1
#define PARENT_READ_FD (pipes[PARENT_READ_PIPE][READ_FD])
#define PARENT_WRITE_FD (pipes[PARENT_WRITE_PIPE][WRITE_FD])
#define CHILD_READ_FD (pipes[PARENT_WRITE_PIPE][READ_FD])
#define CHILD_WRITE_FD (pipes[PARENT_READ_PIPE][WRITE_FD])

// using namespace Stockfish;

int stockfish_main(int argc, char* argv[]);

//     std::cout << engine_info() << std::endl;

//     Bitboards::init();
//     Position::init();

//     UCIEngine uci(argc, argv);

//     Tune::init(uci.engine_options());

//     uci.loop();

//     return 0;
// }


const char *QUITOK = "quitok\n";
int pipes[NUM_PIPES][2];
char buffer[80];

int rose_init()
{
  pipe(pipes[PARENT_READ_PIPE]);
  pipe(pipes[PARENT_WRITE_PIPE]);

  return 0;
}

int rose_main()
{
  dup2(CHILD_READ_FD, STDIN_FILENO);
  dup2(CHILD_WRITE_FD, STDOUT_FILENO);

  int argc = 1;
  char *argv[] = {strdup("")};
  int exitCode = stockfish_main(argc, argv);

  std::cout << QUITOK << std::flush;

  return exitCode;
}

ssize_t rose_stdin_write(char *data)
{
  return write(PARENT_WRITE_FD, data, strlen(data));
}

char *rose_stdout_read()
{
  ssize_t count = read(PARENT_READ_FD, buffer, sizeof(buffer) - 1);
  if (count < 0)
  {
    return NULL;
  }

  buffer[count] = 0;
  if (strcmp(buffer, QUITOK) == 0)
  {
    return NULL;
  }

  return buffer;
}