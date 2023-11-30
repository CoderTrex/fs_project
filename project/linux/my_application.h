#ifndef FLUTTER_MY_projectLICATION_H_
#define FLUTTER_MY_projectLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(Myprojectlication, my_projectlication, MY, projectLICATION,
                     Gtkprojectlication)

/**
 * my_projectlication_new:
 *
 * Creates a new Flutter-based projectlication.
 *
 * Returns: a new #Myprojectlication.
 */
Myprojectlication* my_projectlication_new();

#endif  // FLUTTER_MY_projectLICATION_H_
