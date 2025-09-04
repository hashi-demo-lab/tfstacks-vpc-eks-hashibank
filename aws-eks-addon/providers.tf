terraform {
  
required_providers {
 
  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "~> 2.25"
  }

  time = {
    source = "hashicorp/time"
    version = "~> 0.1"
  }
  

  helm = {
    source = "hashicorp/helm"
    version = "~> 2.12"
  }

  random = {
    source = "hashicorp/random"
    version = "~> 3.7.0"
  }


}
}