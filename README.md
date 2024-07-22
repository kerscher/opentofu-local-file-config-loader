Hierarchical config loader
==========================

Load multiple YAML files into a merged OpenTofu/Terraform value to be used for configurations.
If you ever had to juggle `-var-file=...` or `TF_VAR_foo=...` scripts, this module is for you.

This also helps with sharing configuration files between OpenTofu and other
programs that tend to use YAML files.

Usage
-----

The config files will be read in sequence, with last values winning over older
ones. If a file does not exist it won't be loaded. This is so you can omit
changes on workspaces that don't need to change values from previously loaded
files.

    module "config" {
      source = "github.com/kerscher/opentofu-local-file-config-loader"
    
      config_files = [
        "./config/shared/vars.yaml",
        "./config/environment/${local.environment}/vars.yaml"
      ]
    }

    locals { cfg = module.config.merged }

    resource "reactor_valve" "main" {
      name_prefix       = local.cfg.name_prefix
      release_threshold = local.cfg.release_threshold
    }

Where `local.environment` likely comes from your workspace information so it's
locked to your state. That is, you don't want anything that changes
`config_files` to come from variables or they could be overridden by callers
from the command-line.

Other good candidates for folders on `config/β/vars.yml` for different `β`s below would be:

* `location` or `region`
* `service`
* `cloud_provider`
* `tenant`
