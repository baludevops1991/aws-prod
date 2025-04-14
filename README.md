your-repo/
├── terraform/
│   ├── backend-python/
│   │   ├── main.tf              # Infrastructure (VPC, EC2, etc.)
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── backend.tf           # Remote state config (optional)
│
│   ├── iam/
│   │   ├── codebuild_role.tf    # References to manually created IAM roles
│   │   ├── codedeploy_role.tf   # IAM role for CodeDeploy
│   │   └── codepipeline_role.tf
│
│   ├── codebuild/
│   │   ├── codebuild.tf         # CodeBuild project definition
│   │   └── buildspec.yml        # Build instructions (Terraform init/plan/apply)
│
│   ├── codepipeline/
│   │   └── codepipeline.tf      # Pipeline setup using GitHub as source
│
│   ├── codedeploy/
│   │   ├── appspec.yml          # CodeDeploy configuration file for EC2 deployment
│   │   └── codedeploy.tf        # CodeDeploy setup for EC2 instances
│
│   ├── variables.tf             # Shared variables
│   └── terraform.tfvars         # Variable values (tokens, repo info, ARNs)
│
├── pipeline.json                # Used locally to create CodePipeline
├── .gitignore
└── README.md                    # Documentation for the project setup
