terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.4.0"
    }
    artifactory = {
      source  = "jfrog/artifactory"
      version = "12.3.3"
    }
  }
}

provider "nomad" {
  #export NOMAD_ADDR = ""
  #export NOMAD_TOKEN = ""
}

provider "artifactory" {
  #export ARTIFACTORY_URL
  #export ARTIFACTORY_ACCESS_TOKEN
}

variable "artifactory_repo" {
  type = string
}
variable "nomad_template_path" {
  type = string
}
variable "datacenters" {
  type = string
}
variable "job_prefix" {
  type = string
}
variable "group_count" {
  type    = string
  default = 1
}
variable "artifact_source" {
  type = string
}
variable "workload_config_file_source" {
  type = string
}
variable "jar_path" {
  type = string
}
variable "jvm_options" {
  type = string
}
variable "cpu" {
  type = string
}
variable "memory" {
  type = string
}
variable "consul_service_name" {
  type = string
}

data "artifactory_file" "artfiactory_job_template" {
   repository   = var.artifactory_repo
   path         = var.nomad_template_path
   output_path  = "${path.module}/job-spec-template.tpl"
}

resource "nomad_job" "middleware" {
  jobspec = templatefile("${path.module}/job-spec-template.tpl", {
    datacenters = var.datacenters, job_prefix = var.job_prefix, group_count = var.group_count,
    artifact_source = var.artifact_source, workload_config_file_source = var.workload_config_file_source,
    jar_path = var.jar_path, jvm_options = var.jvm_options, cpu = var.cpu, memory = var.memory, 
    consul_service_name = var.consul_service_name
  })
}