
datacenters                 = "global"
job_prefix                  = "hello-world"
group_count                 = 1
artifact_source             = "git::https://github.com/fhemberger/nomad-demo.git//nomad_jobs/artifacts/hello-world-java/"
workload_config_file_source = "https://path.to/config.xml"
jar_path                    = "HelloWorld.jar"
jvm_options                 = "-Dhelloworld.port=$${NOMAD_PORT_http}"
cpu                         = "100"
memory                      = "50"
consul_service_name         = "hello-world"
