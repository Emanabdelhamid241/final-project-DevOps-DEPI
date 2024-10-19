# output "vpc_id" {
#   value = aws_vpc.terravpc.id
# }
output "server"{
    value = join ("",["http://",aws_instance.JenkinsServer.public_dns,":","8080"])
}