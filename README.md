# terraform environments

## Project initialize.

Run once when the project starts.  
**run the command below with your** `PROJECT-NAME`.  
All resource will replace with the `PROJECT-NAME` .

```
# OSX
$ grep -rl "{{ .Project }}" region/ modules/ | xargs sed -i.bak -e 's/{{ .Project }}/PROJECT-NAME/g' && find . -name "*.bak" | xargs rm
```

## The way to use

1. create s3 bucket.
2. initialize
3. select workspace
4. deploy

### create s3 bucket

create s3 bucket from aws console.


### Development

```
$ cd region/ap-northeast-2
$ terraform init
$ terraform workspace new development
$ terraform workspace select development
$ cp development.tfvars.example development.tfvars
$ terraform plan -var-file=development.tfvars 
$ terraform apply -var-file=development.tfvars -auto-approve | tee -a log
$ sh search.sh
```

### Production

```
$ cd region/ap-northeast-1
$ terraform init
$ terraform workspace new production
$ terraform workspace select production
$ cp production.tfvars.example production.tfvars
$ terraform plan -var-file=production.tfvars 
$ terraform apply -var-file=production.tfvars -auto-approve | tee -a log
$ sh search.sh
```
