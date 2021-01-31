#!/bin/bash

terraform plan -var='containers=[{name="test", access_type="private"},]'
terraform apply -var='containers=[{name="test", access_type="private"},]' --auto-approve