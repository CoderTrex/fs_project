#include "my_projectlication.h"

int main(int argc, char** argv) {
  g_autoptr(Myprojectlication) project = my_projectlication_new();
  return g_projectlication_run(G_projectLICATION(project), argc, argv);
}
