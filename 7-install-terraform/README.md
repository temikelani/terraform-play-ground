# Install Terraform on Windows & Linux <a id ='top'></a>

<br>
<br>

# Conte

- [Setup](#setup)
- [On Windows](#0)
- [On Linux](#1)
- [To-Do](#to-do)
- [go to top](#top)

<br>
<br>

# Setup <a id='setup'></a> ([go to top](#top))

- Create a keypair named `948533770478`
- setup Enviroment by deploying this [cfn template](./setup.yml)
- Connect to Instances via ssh or session manager

<br>
<br>

# On Windows <a id='0'></a> ([go to top](#top))

<details>
<summary>>  Run the following commands</summary>

```powershell
# make a new directory for Terraform
mkdir C:\terraform
cd C:\terraform

# Download the Terraform binary using Invoke-WebRequest:
Invoke-WebRequest -Uri  https://releases.hashicorp.com/terraform/1.2.2/terraform_1.2.2_windows_amd64.zip -outfile
terraform_1.2.2_windows_amd64.zip

# Use Expand-Archive to extract the binary from the zip file and remove the zip file from the director
Expand-Archive -Path .\terraform_1.2.2_windows_amd64.zip -DestinationPath .\
rm .\terraform_1.2.2_windows_amd64.zip -Force

# Set the Terraform directory as a PATH variable:
setx PATH "$env:path;C:\terraform" -m

# Update the current PowerShell session with the new environment variable:
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Confirm Terraform is installed
terraform version
```

</details>

<br>
<br>
<br>

# On Linux <a id='1'></a> ([go to top](#top))

<details>
<summary>> Coming Soon </summary>

```bash
#  Change directory to home:
cd ~/

# Use wget to download the Terraform zip file:
wget https://releases.hashicorp.com/terraform/1.2.2/terraform_1.2.2_linux_amd64.zip

#  Unzip the zip file using the unzip command:
unzip terraform_1.2.2_linux_amd64.zip

# Move the terraform binary to the /usr/local/bin directory:
sudo mv terraform /usr/local/bin

# Verify that Terraform is installed:
terraform version
```


</details>

<br>
<br>
<br>

# Via CLI/Bash Script<a id='2'></a> ([go to top](#top))

<details>
<summary>> Coming Soon </summary>

</details>

<br>
<br>
<br>

# Via Console <a id='3'></a> ([go to top](#top))

<details>
<summary>> Coming Soon </summary>

</details>

<br>
<br>
<br>

# Resources <a id='res'></a> ([go to top](#top))

- [Download Terraform](https://www.terraform.io/downloads)
  <br>
  <br>
  <br>

# To-Do <a id='to-do'></a> ([go to top](#top))

<br>
<br>
<br>
