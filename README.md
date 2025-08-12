# matt-tgw-poc

A learning-focused proof-of-concept to understand how two AWS VPCs in different regions can connect via an AWS Transit Gateway (TGW) using a centralized egress model.

- **VPC A**: ap-southeast-2 (Sydney)
- **VPC B**: ap-southeast-1 (Singapore)
- **Transit Gateway**: ap-southeast-2 (Sydney)
- **Cross-region attach**: via AWS RAM share

### Why this matters
Centralizing egress via a TGW reduces duplication (e.g., multiple NATs), simplifies inspection, and enforces consistent security controls across VPCs.

### Architecture (Mermaid)
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

### What we’ll do next (step-by-step commits)
1) Scaffold minimal Terraform (providers, two VPCs, TGW)
2) Add cross-region attachment (RAM share + accept)
3) Add routing so VPC A <-> VPC B via TGW
4) Optional: tiny EC2s for ping tests
5) Add a draw.io diagram to `/diagram/`

This repo is intentionally minimal to support learning by iterating in small, focused commits.