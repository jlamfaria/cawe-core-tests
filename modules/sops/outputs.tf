output "secret_content" {
    sensitive = false
    value     = var.input_type == "raw" ? data.sops_file.sops.raw : var.secret_key == null ? jsonencode(data.sops_file.sops.data) : data.sops_file.sops.data[var.secret_key]
}
