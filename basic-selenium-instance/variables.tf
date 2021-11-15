variable "aws_region" {
  default = "us-east-2"
  description = "The AWS region to use"
}

variable "spot_price" {
  default = "0.004"
  description = "The maximum price per hour willing to pay for EC2 instance (spot request)"
}

variable "gecko_dl_url" {
  default = "https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz"
  description = "The download URL (from Github) for latest version of Geckodriver"
}

variable "tor_dl_url" {
  default = "https://www.torproject.org/dist/torbrowser/11.0/tor-browser-linux64-11.0_en-US.tar.xz"
  description = "The download URL for latest version of Tor Browser"
}

variable "ec2_key_name" {
  description = "The name of the EC2 instance key pair to use for the Selenium EC2 instance"
}