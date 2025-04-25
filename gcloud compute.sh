gcloud compute instances detach-disk pigidii --disk=disk-1 --zone=us-central1-c && gcloud compute instances delete pigidii --zone=us-central1-c --quiet

gcloud compute instances create pigidii \
     --zone=us-central1-c \
     --machine-type=n2-standard-4 \
     --image-family=debian-12 \
     --image-project=debian-cloud \
     --boot-disk-size=10GB \
     --boot-disk-type=pd-balanced \
     --tags=http-server,https-server,px \
     --subnet=default \
     --can-ip-forward \
     --enable-nested-virtualization \
     --network-tier=STANDARD

gcloud compute instances add-metadata pigidii \
   --metadata key=value --zone=us-central1-c
gcloud compute instances add-metadata pigidii \
   --metadata serial-port-enable=TRUE --zone=us-central1-c
gcloud compute instances add-metadata pigidii --zone=us-central1-c \
   --metadata "ssh-keys=doctormetis:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPKyO0RMcJoFvTcH+m5kyj6niaDwAD4q5fqJYNlcZpA"

#gcloud compute connect-to-serial-port pigidii --zone=us-central1-c

gcloud compute instances describe pigidii --zone=us-central1-c --format='get(networkInterfaces[0].accessConfigs[0].natIP)'