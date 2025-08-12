# TGW PoC: Cross-Region VPC Connectivity (Sydney ↔ Singapore)

This repository contains a Terraform proof-of-concept to connect two AWS VPCs located in different regions using an AWS Transit Gateway (TGW) with centralized egress.

- **VPC A**: ap-southeast-2 (Sydney)
- **VPC B**: ap-southeast-1 (Singapore)
- **Transit Gateway**: ap-southeast-2 (Sydney)
- **Cross-region attach**: via AWS RAM share

We follow centralized egress principles similar to PalawanPay's architecture: outbound traffic is aggregated through the TGW, enabling consistent egress controls, inspection, and shared services access.

## Diagram (Mermaid)

```mermaid
flowchart LR
  subgraph SYD["ap-southeast-2 (Sydney)"]
    A[VPC A]
    TGW[Transit Gateway]
    A ---|VPC Attachment| TGW
  end

  subgraph SIN["ap-southeast-1 (Singapore)"]
    B[VPC B]
  end

  B ---|Cross-Region VPC Attachment (RAM)| TGW
```

## High-level
- TGW created in Sydney
- VPC A (Sydney) and VPC B (Singapore) are attached
- Route tables on subnets/VPCs point inter-VPC traffic via TGW
- AWS RAM used for cross-account/region share if needed

## Getting Started
1. Ensure you have appropriate AWS credentials with permissions for VPC, TGW, RAM.
2. Terraform >= 1.6 recommended.
3. Initialize and plan:
   ```bash
   terraform init
   terraform plan -out tfplan
   ```
4. Apply:
   ```bash
   terraform apply tfplan
   ```

## Connectivity Test (optional)
- Deploy small EC2 instances in each VPC (modules provided) and attempt ICMP or TCP tests across private IPs.

## Notes on centralized egress
- Central TGW simplifies outbound inspection and egress policy.
- Decentralized egress can lead to inconsistent security and duplicated NAT costs; TGW centralization addresses this by routing through shared services/egress.

## draw.io
A `diagram/tgw-poc.drawio` file will be added. Export PNG/SVG for docs if desired.
