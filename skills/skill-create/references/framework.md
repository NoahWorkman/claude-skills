# Skill Categories Framework

9 categories for classifying Claude Code skills. Every skill should fit one category. If it straddles two, the primary workflow determines the category.

## 1. Library/API Reference

Skills that wrap external APIs, SDKs, or documentation into callable workflows. The skill knows the API shape so Claude doesn't have to re-discover it each time.

**Examples:** API wrapper skills, SDK integration helpers

## 2. Product Verification

Skills that test, validate, or QC a product artifact. They run checks and report pass/fail.

**Examples:** QA runners, accessibility auditors, screenshot validators

## 3. Data Fetching

Skills that retrieve, aggregate, or transform data from external systems. Output is structured data, not actions.

**Examples:** email summarizers, CRM data pullers, log aggregators

## 4. Business Process

Skills that orchestrate multi-step business workflows with decision points, approvals, or handoffs. They coordinate rather than execute a single action.

**Examples:** content pipelines, strategy sessions, onboarding workflows

## 5. Code Scaffolding

Skills that generate project structures, templates, or boilerplate. They create files and directories based on patterns.

**Examples:** project generators, skill creators, boilerplate scaffolders

## 6. Code Quality

Skills that analyze, lint, review, or improve existing code. They read code and suggest or apply changes.

**Examples:** code simplifiers, security scanners, project auditors

## 7. CI/CD & Deployment

Skills that build, deploy, publish, or manage release processes. They interact with hosting, CI, or package registries.

**Examples:** deploy checkers, commit-and-push helpers, release publishers

## 8. Runbooks

Skills that guide investigation or response to incidents, questions, or recurring situations. They encode institutional knowledge as structured steps.

**Examples:** daily briefings, conversation retrospectives, session handoffs

## 9. Infrastructure Ops

Skills that manage infrastructure, environments, resources, or system configuration. They modify the operating environment rather than application code.

**Examples:** calendar blockers, file managers, environment setup tools
