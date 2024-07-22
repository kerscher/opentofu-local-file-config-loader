variable "config_files" {
  type = list(string)
  description = "Ordered sequence of YAML configuration files to load. Last ones win precedence in case of conflicts"
}

data "local_file" "config" {
  for_each = { for i, v in var.config_files : i => v if fileexists(v) }
  filename = each.value
}

locals { 
  yamls = [for x in data.local_file.config : {
     filename = x.filename,
     content =  yamldecode(x.content),
    }
  ]
 }

output "full" {
  description = "All config values after being decoded. Might have redundant information."
  value = local.yamls
}

output "merged" {
  description = "Single object merging all values from config_files. Meant to be used as the configuration source for the project."
  value = merge([for y in local.yamls : y.content]...)
}
