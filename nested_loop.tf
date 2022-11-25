locals {
    pnon_dev = [
        "user:A",
        "user:B"
    ]
    pnon_permissions = [
        "roles/compute.osLogin",
        "roles/iap.tunnelResourceAccessor",
        "roles/container.developer",
        "roles/container.clusterViewer"
    ]

    user_roles_mapping = distinct(flatten([
    for user in local.pnon_dev : [
      for role in local.pnon_permissions : {
        member = user
        role    = role
      }
    ]
  ]))
}


resource "google_project_iam_member" "pnon_gke" {
    for_each      = { for entry in local.user_roles_mapping: "${entry.member}.${entry.role}" => entry }
    project = "AAAA-sandbox"
    role = each.value.role
    member = each.value.member
}
