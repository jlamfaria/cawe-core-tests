data "sops_file" "sops" {
    source_file = var.secret_file
    input_type = var.input_type
}
