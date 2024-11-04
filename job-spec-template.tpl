  job "${job_prefix}-job" {
  datacenters = ["${datacenters}"]
  type        = "service"

  # Specify this job to have rolling updates, with 30 second intervals.
  update {
    stagger      = "30s"
    max_parallel = 1
  }

  # A group defines a series of tasks that should be co-located
  # on the same client (host). All tasks within a group will be
  # placed on the same host.
  group "${job_prefix}-group" {
    # Specify the number of these tasks we want.
    count = ${group_count}

    restart {
      attempts = 3
      interval = "2m"
      delay    = "15s"
      mode     = "fail"
    }

    network {
      port "http" {}
    }

    task "${job_prefix}-task" {
      driver = "java"

      #Download the jar file
      artifact {
        source = "${artifact_source}"
        #destination = "" defaults to local/
      }

      #Download workload config file (optional)
      #artifact {
      #  source = "${workload_config_file_source}"
      #  mode = "file"
      #  destination = "" defaults to local/
      #}
      
      #Set an environment variable for the config file path (optional)
      #env {
      #  CONFIG_FILE_PATH = "local/config.xml"
      #}

      config {
        jar_path    = "local/${jar_path}"
        jvm_options = ["${jvm_options}"]
      }

      resources {
        cpu    = ${cpu}
        memory = ${memory}
      }

      service {
        name = "${consul_service_name}"
        tags = ["http"]
        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}