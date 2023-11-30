#include "my_projectlication.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _Myprojectlication {
  Gtkprojectlication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(Myprojectlication, my_projectlication, GTK_TYPE_projectLICATION)

// Implements Gprojectlication::activate.
static void my_projectlication_activate(Gprojectlication* projectlication) {
  Myprojectlication* self = MY_projectLICATION(projectlication);
  GtkWindow* window =
      GTK_WINDOW(gtk_projectlication_window_new(GTK_projectLICATION(projectlication)));

  // Use a header bar when running in GNOME as this is the common style used
  // by projectlications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "project");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "project");
  }

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements Gprojectlication::local_command_line.
static gboolean my_projectlication_local_command_line(Gprojectlication* projectlication, gchar*** arguments, int* exit_status) {
  Myprojectlication* self = MY_projectLICATION(projectlication);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_projectlication_register(projectlication, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_projectlication_activate(projectlication);
  *exit_status = 0;

  return TRUE;
}

// Implements Gprojectlication::startup.
static void my_projectlication_startup(Gprojectlication* projectlication) {
  //Myprojectlication* self = MY_projectLICATION(object);

  // Perform any actions required at projectlication startup.

  G_projectLICATION_CLASS(my_projectlication_parent_class)->startup(projectlication);
}

// Implements Gprojectlication::shutdown.
static void my_projectlication_shutdown(Gprojectlication* projectlication) {
  //Myprojectlication* self = MY_projectLICATION(object);

  // Perform any actions required at projectlication shutdown.

  G_projectLICATION_CLASS(my_projectlication_parent_class)->shutdown(projectlication);
}

// Implements GObject::dispose.
static void my_projectlication_dispose(GObject* object) {
  Myprojectlication* self = MY_projectLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_projectlication_parent_class)->dispose(object);
}

static void my_projectlication_class_init(MyprojectlicationClass* klass) {
  G_projectLICATION_CLASS(klass)->activate = my_projectlication_activate;
  G_projectLICATION_CLASS(klass)->local_command_line = my_projectlication_local_command_line;
  G_projectLICATION_CLASS(klass)->startup = my_projectlication_startup;
  G_projectLICATION_CLASS(klass)->shutdown = my_projectlication_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_projectlication_dispose;
}

static void my_projectlication_init(Myprojectlication* self) {}

Myprojectlication* my_projectlication_new() {
  return MY_projectLICATION(g_object_new(my_projectlication_get_type(),
                                     "projectlication-id", projectLICATION_ID,
                                     "flags", G_projectLICATION_NON_UNIQUE,
                                     nullptr));
}
