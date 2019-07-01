provider "azurerm" {
  version = "1.30.1"
}

provider "azuread" {
  version = "0.4.0"
}

provider "random" {
  version = "2.1.2"
}

/* 
01d4889c-1287-42c6-ac1f-5d1e02578ef6 Read files in all site collections (preview)          
089fe4d0-434a-44c5-8827-41ba8a0b17f5 Read contacts in all mailboxes                        
1138cb37-bd11-4084-a2b7-9f71582aeddb Read and write devices                                
19dbc75e-c2e2-444c-a770-ec69d8559fc7 Read and write directory data                         
230c1aed-a721-4c5d-9cb4-a90514e508ef Read all usage reports                                
5b567255-7703-4780-807c-7be8301ae99b Read all groups                                       
62a82d76-70ea-41e2-9197-370581804d09 Read and write all groups                             
658aa5d8-239f-45c4-aa12-864f4fc7e490 Read all hidden memberships                           
6918b873-d17a-4dc1-b314-35f528134491 Read and write contacts in all mailboxes              
6931bccd-447a-43d1-b442-00a195474933 Read and write all user mailbox settings (preview)    
6e472fd1-ad78-48da-a0f0-97ab2c6b769e Read all identity risk event information              
741f803b-c850-494e-b5df-cde7c675a1ca Read and write all users' full profiles               
75359482-378d-4052-8f01-80520e7db3cd Read and write files in all site collections (preview)
798ee544-9d2d-430c-a058-570e29e34338 Read calendars in all mailboxes                       
7ab1d382-f21e-4acd-a863-ba3e13f7da61 Read directory data                                   
810c84a8-4a9e-49e6-bf7d-12d183f40d01 Read mail in all mailboxes                            
b633e1c5-b582-4048-a93e-9f11b44c7e96 Send mail as any user                                 
df021288-bdef-4463-88db-98f22de89214 Read all users' full profiles                         
e2a3a72e-5f79-4c64-b1b1-878b674786c9 Read and write mail in all mailboxes                  
ef54d2bf-783f-4e0f-bca1-3210c0444d99 Read and write calendars in all mailboxes
1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9 Read and write all Applications
*/

resource "azuread_application" "application" {
  name = "${var.sp_name}"
}

resource "azuread_service_principal" "service_principal" {
  application_id = "${azuread_application.application.application_id}"
}

resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = "${azuread_service_principal.service_principal.id}"
  value                = "${random_string.password.result}"
  end_date             = "2025-01-01T01:02:03Z"
}

resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "/@\" "
}
