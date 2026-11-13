# Job Recruitment & Career Portal

A database-driven web application designed to manage the recruitment process by connecting job seekers, employers, and companies through a centralized platform. The system supports job listings, resume management, job applications, interview scheduling, job offers, and company reviews.

## Project Overview

The **Job Recruitment & Career Portal** was developed as part of the CSE302: Database Systems course at East West University during Spring 2026.

The application was built using Oracle APEX, with a relational database structure designed to manage recruitment-related information and operations. It provides administrative management features, data entry forms, query-based reports, and role-based access control.

## Features

### 1. Job Seeker Management
- View and manage job seeker records.
- Maintain job seeker information.
- Associate resumes and applications with job seekers.

### 2. Employer Management
- Maintain employer records.
- Manage employer-related information.

### 3. Company Management
- Add, edit, and delete company records.
- View company information.

### 4. Job Management
- Manage job listings.
- Associate jobs with their respective companies.
- Edit existing job records.

### 5. Resume Management
- Maintain resume records.
- Associate resumes with their respective job seekers.

### 6. Application Management
- Track job applications.
- View applicant, job, and company information through multi-table reports.

### 7. Interview Management
- Manage interview records.
- Associate interviews with applications and job seekers.

### 8. Job Offer Management
- Add, edit, and delete job offers.
- Connect offers with candidates, jobs, applications, and companies.

### 9. Company Reviews
- Allow job seekers to write company reviews.
- Manage existing reviews.
- View reviews associated with companies and their authors.

## Database Features

- Relational database schema and E-R model.
- Database schema design with interconnected tables.
- Multi-table SQL queries.
- Aggregate queries.
- Query-based reports.
- Forms for inserting and managing records.
- Database trigger for automatic timestamp updates.
- Custom authentication using PL/SQL.
- Role-Based Access Control (RBAC).

## Authentication and Access Control

The application implements a custom authentication mechanism using a PL/SQL authentication function.

It distinguishes between administrative and standard users and dynamically controls access to restricted pages and administrative interface elements.

The system also uses a database trigger named `trg_resume_update` to automatically update the `updated_at` timestamp whenever a resume record is modified.

## Demo Login Credentials

Use the following credentials to access the application.

### Standard User Accounts

| Username | Password |
|---|---|
| `tuli` | `123` |
| `harrypotter` | `456` |

### Administrator Account

| Role | Username | Password |
|---|---|---|
| Admin | `nurtazreza876@gmail.com` | `alohomora` |

## Reports and Forms

The application includes management reports and corresponding forms for major recruitment entities, including:

- Job Seekers
- Employers
- Companies
- Skills
- Jobs
- Resumes
- Applications
- Interviews
- Offers
- Company Reviews

It also provides multi-table reports that combine related information, such as applicants with their job applications, jobs with company details, and interviews with candidate information.

## Technology Stack

| Technology | Purpose |
|---|---|
| Oracle APEX | Application development and user interface |
| SQL | Database queries and data management |
| PL/SQL | Custom authentication and database logic |
| Relational Database | Structured data storage and relationships |


---

**Developed as an academic project for CSE302: Database Systems, East West University.**
