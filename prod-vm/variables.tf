variable "prefix" {
  description = "Short name stamped on every resource (rg-<prefix>, vm-<prefix>, ...)."
  type        = string
  default     = "azprod"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "vm_size" {
  description = "B-series burstable keeps the lab cheap; size up for real workloads."
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

# --- Hardening toggles --------------------------------------------------------
variable "enable_trusted_launch" {
  description = "Secure boot + vTPM. Needs a gen2, Trusted-Launch-capable image."
  type        = bool
  default     = true
}

variable "enable_encryption_at_host" {
  description = "Encrypt temp disk/caches at the host. Requires one-time feature registration (see README)."
  type        = bool
  default     = true
}

# --- Auto-shutdown ------------------------------------------------------------
variable "shutdown_time" {
  description = "Daily auto-shutdown in 24h HHMM, local to the timezone below."
  type        = string
  default     = "1900"
}

variable "timezone" {
  description = "Windows timezone name for the shutdown schedule."
  type        = string
  default     = "Eastern Standard Time"
}

# --- Image: AlmaLinux 9 gen2 (free, RHEL-family, SELinux enforcing) -----------
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
