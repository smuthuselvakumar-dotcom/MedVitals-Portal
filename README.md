# MedVitals - Multi-Tenant Home Healthcare & Lab Booking Portal

An enterprise-grade, fully authenticated 10-step medical booking SaaS platform built with **React (Vite + TypeScript + Tailwind CSS)** and **.NET Core Web API (EF Core + SQL Server)**.

## 🌟 Key Architectural Highlights
- **Multi-Tenant (SaaS) Architecture:** Single-database tenant isolation where each healthcare provider (e.g., Apollo, Lal Pathlabs) drives its own branding (Logo), dynamic styling themes (Primary/Secondary colors via CSS variables), and font styles based on domain or query context.
- **Lazy Authentication:** Users can seamlessly browse and select lab services before being prompted to log in or register.
- **Smart Validation & Stepper Control:** An advanced conditional state-machine flow that auto-skips valid profile pages and dynamically halts or forces manual inputs if required data fields are missing/invalid.
- **Session Control & Inactivity Protection:** Token persistence handling via secure localized state with an automated 15-minute user inactivity auto-logout mechanism.

## 🛤 The 10-Step Smart Journey Matrix
1. **Select Service** - Choose lab tests or packages (No auth required).
2. **Login / Register** - Dynamic gateway (Auto-skipped if an active JWT token already exists in the browser).
3. **Select Family Member** - Choose between booking for `Self` or saved dependent family profiles.
4. **Patient Details** - *[Autofill/Stop]* Auto-skips if existing data is complete and valid; stops for manual override if updates are required.
5. **Medical / Insurance Card** - *[Autofill/Stop]* Displays, validates, or collects insurance card and policy details.
6. **Select Address / Visit Lab** - *[Skip/Autofill]* Renders saved tenant addresses highlighting the user's default. Skips completely if "Lab Walk-in" is selected.
7. **Select Date & Time Slot** - Mandated calendar and time-slot allocator for both Home and Lab visits.
8. **Review Page** - Comprehensive, immutable breakdown of booking details before final checkout.
9. **Payment Page** - Secured mock transactional payment processing pipeline.
10. **Success Page** - Booking confirmation screen with localized receipt and booking track record generation.