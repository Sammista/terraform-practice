#AWS Credentials. 
# We don't want to store the values in here because that isn't secure.
# use the var flag when running terraform commands and supply the values. See the readme for more details.
variable "access_key" {
type =string
sensitive = true

}

variable "secret_key" {
type =string
sensitive = true

}