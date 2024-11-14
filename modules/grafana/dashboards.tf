resource "grafana_folder" "spaceship" {
    title = "Spaceship"
}

resource "grafana_folder" "spaceship_users" {
    title = "Spaceship-Users"
}

resource "grafana_folder" "jaws" {
    title = "JAWS"
}

resource "grafana_dashboard" "spaceship_dashboards" {
    for_each    = fileset(path.module, "dashboards/spaceship/*.json")
    config_json = file("${path.module}/${each.value}")
    overwrite   = true
    folder      = grafana_folder.spaceship.uid
}

resource "grafana_dashboard" "spaceship-users_dashboards" {
    for_each    = fileset(path.module, "dashboards/spaceship-users/*.json")
    config_json = file("${path.module}/${each.value}")
    overwrite   = true
    folder      = grafana_folder.spaceship_users.uid
}


resource "grafana_dashboard" "jaws_dashboards" {
    for_each    = fileset(path.module, "dashboards/jaws/*.json")
    config_json = file("${path.module}/${each.value}")
    overwrite   = true
    folder      = grafana_folder.jaws.uid
}

resource "grafana_folder_permission_item" "jaws_admin" {
  folder_uid = grafana_folder.jaws.uid
  role       = "Editor"
  permission = "Admin"
}

resource "grafana_folder_permission_item" "spaceship_admin" {
  folder_uid = grafana_folder.spaceship.uid
  role       = "Editor"
  permission = "Admin"
}

resource "grafana_folder_permission" "spaceship" {
    folder_uid = grafana_folder.spaceship.uid
    permissions {
        role       = "Admin"
        permission = "Admin"
    }
}

resource "grafana_folder_permission" "spaceship-users" {
    folder_uid = grafana_folder.spaceship_users.uid
    permissions {
        role       = "Admin"
        permission = "Admin"
    }
    permissions {
        role       = "Viewer"
        permission = "View"
    }
}
