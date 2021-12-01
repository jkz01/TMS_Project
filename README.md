### DevOps project


1.	Create k8s cluster with kubespray(for example: 1 master, 1 etcd, 2 workers):
a.	AWS infra should be created with terraform.
b.	Inventory file can be created from terraform output. For storing inventory you can use s3 bucket. 
c.	Based on requirement your kubespray pipeline should create a new cluster or update(scale) existing one.
	
2.	Build your app(docker image). Use a short git hash commit as part of your image tag. Further deployment should be processed with this tag:
a.	After getting commit into master branch run the image build pipeline for your application.
b.	If Build your image. Run tests of your docker image.
c.	If previous steps are fine - push the image to your private registry.


3.	Test your app deployment.
a.	Deploy helm chart using your latest image in test ns.
b.	Validate that it’s up and running
c.	Perform small tests, curl for example
d.	Send notification to slack


4.	Run actual deployment of your application with helm.
a.	Perform curl check
b.	Send notification to slack

