<div align="center"><img src="https://search.nixos.org/images/nix-logo.png"></div>
<h1 align="center">NixOS but not annoying</h1>

<div align="center">

![nixos](https://img.shields.io/badge/NixOS-24273A.svg?style=flat&logo=nixos&logoColor=CAD3F5)
![nixpkgs](https://img.shields.io/badge/nixpkgs-unstable-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8aadf4)
![kde version](https://img.shields.io/badge/kde-5-blue?logo=kde)

</div>

# What this solves
**NixOS is wildly cool** but absolutely blows at explaining why. It's good because:
1. It allows you to run multiple versions of the same package without interference
2. It allows us to declaratively configure a system, like a `package.json` for a node project
3. Any changes to the os can be reverted

**Buuuuuut** it *sucks to configure and debug*, we can fix this by streamlining the configuration process. Most people have their own process but I belive this is an excellent starting point, all thanks to [Tristram Oaten](https://github.com/0atman) for the script. 
# Installation Process
## Step 1: Install NixOS
There are plenty of online resources availible for installing the platform like the [Official Install Guide](https://nixos.wiki/wiki/NixOS_Installation_Guide) to learn how to install
## Step 2: Clone this repo into your users home directory
```
cd
git clone https://github.com/carterjandrew/nixos-config.git
```
Then move inside the repo to start setting things up
```
cd nixos-config
```
## Step 3: Create a `user-config.nix` file
This acts as a file holding some variables personal to your build. You can find a template with all 4 of the fields you need called `.user-config.nix`. All fields must be filled out to work, and should match the user you set up during installation. 
```
vim .user-config.nix
```
### Example user config:
```
{
  # Your linux machine username for your main user, for example mine is "carter"
  mainUserName = "carter";
  # The name you want to display for your user, for example mine is "Carter Andrew"
  mainUserDescription = "Carter Andrew";
  # Your git username for git conifg, for example mine is "Carter Andrew" again
  gitUserName = "Carter Andrew";
  # Your git email for git config, for example mine is "carterexampleemail@gmail.com"
  gitUserEmail = "carterexampleemail@gmail.com";
}
```
Then copy this over to your `/ect/nixos` directory. If you update this file in the future, remeber it needs to be updated in the `/ext/nixos` directory as well
```
sudo cp .user-config.nix /ect/nixos/user-config.nix
```
## Step 4: Move over the nixos-configuration file
*Note that if you're going to change the system.stateVersion to update nixos it is availible in this configuration file*
You really shouldnt have to edit this file. It's mainly just for importing your configuration from *this* folder.   
I'd say it's wise to make a backup of your current nixos configuration in case you don't like my setup. You can just copy it and call it a .backup file
```
sudo cp /ect/nixos/configuration.nix /ect/nixos/configuration.nix.backup
```
Then copy over this version
```
sudo cp .configuration.nix /ect/nixos/configuration.nix
```
## Step 5: Rebuild nixos using the script
```
./scripts/rebuild
```
Report any issues you have in the [issues tab](https://github.com/carterjandrew/nixos-config/issues) of this github and I'll do my best to address them.   
# How to use your setup
**TODO**