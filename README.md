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
│   │   ├── codedeploy_role.tf   # Optional, only if using CodeDeploy
│   │   └── codepipeline_role.tf
│
│   ├── codebuild/
│   │   ├── codebuild.tf         # CodeBuild project definition
│   │   └── buildspec.yml        # Build instructions (Terraform init/plan/apply)
│
│   ├── codepipeline/
│   │   └── codepipeline.tf      # Pipeline setup using GitHub as source
│
│   ├── variables.tf             # Shared variables
│   └── terraform.tfvars         # Variable values (tokens, repo info, ARNs)
│
├── appspec.yml                  # Only if CodeDeploy to EC2 is used
├── scripts/                     # Optional scripts if using EC2 + CodeDeploy
│   ├── install_dependencies.sh
│   └── start_server.sh
├── pipeline.json                # Used locally to create CodePipeline
├── .gitignore
└── README.md
