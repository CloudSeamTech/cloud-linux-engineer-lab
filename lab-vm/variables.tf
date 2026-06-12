variable "prefix" {
  description = "Short name stamped on every resource (rg-<prefix>, vm-<prefix>, ...)."
  type        = string
  default     = "azlab"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "vm_size" {
  description = "B-series burstable = cheap. Deallocate when idle. B1s is even cheaper."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to your PUBLIC key. Make one first: ssh-keygen -t ed25519"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "allow_ssh_cidr" {
  description = "Your public IP as a /32 (least privilege). Find it: curl ifconfig.me  ->  e.g. 203.0.113.5/32"
  type        = string
  # no default on purpose — you MUST set this, so SSH is never open to the world.
}

# --- Image: AlmaLinux 9 (free, RHEL-family, SELinux). Verify SKU per the README. ---
variable "image_publisher" {
  type    = string
  default = "almalinux"
}
variable "image_offer" {
  type    = string
  default = "almalinux-x86_64"
}
variable "image_sku" {
  type    = string
  default = "9-gen2"
}
variable "image_version" {
  type    = string
  default = "latest"
}
