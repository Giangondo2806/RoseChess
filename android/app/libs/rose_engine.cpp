#include "rose_engine.h"

#include <iostream>
#include <stdio.h>
#include <cstring>
#include <unistd.h>

#include "rose/bitboard.h"
#include "rose/misc.h"
#include "rose/position.h"
#include "rose/uci.h"
#include "rose/tune.h"


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


using namespace Stockfish;

int main(int argc, char* argv[]);

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
  int exitCode = main(argc, argv);

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