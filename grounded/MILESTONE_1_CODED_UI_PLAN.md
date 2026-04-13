# Pact Milestone 1 Coded UI Plan

> **For agentic workers:** Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Membangun seluruh flow UI MVP Pact di SwiftUI dengan mock data dan navigasi dummy, tanpa logic produk yang sesungguhnya.

**Architecture:** Milestone ini hanya fokus pada presentasi visual, komposisi layar, reusable components, dan previewability. Semua state memakai mock data lokal supaya setiap screen bisa dibangun, diuji visualnya, dan didemokan tanpa SwiftData, timer real, notification, atau lifecycle handling.

**Tech Stack:** SwiftUI

---

## Scope Milestone 1

### Harus Selesai
- Onboarding screen
- Create Focus Contract screen
- Active Focus Session screen
- Consequence Replay screen
- Reflection Report screen
- Preview state untuk notification dan Live Activity
- Navigasi dummy end-to-end antar screen
- Design system kecil untuk style yang konsisten

### Belum Masuk Milestone Ini
- SwiftData
- ActivityKit logic
- UserNotifications permission dan scheduling
- Timer real-time
- Break detection dari `scenePhase`
- Haptics
- Persistence

## Proposed File Structure

### Entry and App Flow
- `grounded/groundedApp.swift`
  - App entry point
- `grounded/ContentView.swift`
  - Root container sementara untuk flow milestone 1

### App Shell
- `grounded/App/PactAppFlow.swift`
  - Mengatur navigasi dummy seluruh flow utama
- `grounded/App/PactRoute.swift`
  - Enum route/screen untuk flow preview

### Design System
- `grounded/DesignSystem/PactColors.swift`
  - Color roles utama aplikasi
- `grounded/DesignSystem/PactSpacing.swift`
  - Spacing constants
- `grounded/DesignSystem/PactTypography.swift`
  - Typography helper
- `grounded/DesignSystem/PactButtonStyle.swift`
  - Primary/secondary button style
- `grounded/DesignSystem/PactCard.swift`
  - Reusable card wrapper

### Mock Models
- `grounded/Mocks/MockFocusContract.swift`
  - Mock contract data untuk UI
- `grounded/Mocks/MockFocusSession.swift`
  - Mock session/report data
- `grounded/Mocks/MockReplayData.swift`
  - Mock consequence replay content

### Screens
- `grounded/Screens/Onboarding/OnboardingView.swift`
- `grounded/Screens/Contract/CreateFocusContractView.swift`
- `grounded/Screens/Session/ActiveFocusSessionView.swift`
- `grounded/Screens/Replay/ConsequenceReplayView.swift`
- `grounded/Screens/Report/ReflectionReportView.swift`

### Reusable UI Components
- `grounded/Components/PactScreenContainer.swift`
  - Layout wrapper dengan spacing dan alignment konsisten
- `grounded/Components/PactSectionHeader.swift`
  - Judul section + supporting text
- `grounded/Components/PactTonePicker.swift`
  - UI tone selector
- `grounded/Components/PactMetricCard.swift`
  - Card untuk angka/summary
- `grounded/Components/PactPrimaryButton.swift`
  - Wrapper tombol CTA utama
- `grounded/Components/PactSecondaryButton.swift`
  - Wrapper tombol sekunder

### Preview-Only Supporting Views
- `grounded/Screens/Notification/BreakAlertPreviewView.swift`
  - Visualisasi notification content
- `grounded/Screens/LiveActivity/LiveActivityPreviewView.swift`
  - Visualisasi compact/live state

## UI Direction

- Visual harus terasa tenang, serius, dan personal.
- Hindari dashboard yang ramai; utamakan satu fokus utama per layar.
- Timer dan consequence copy harus jadi focal point yang jelas.
- Tone selector harus mudah dibedakan tanpa terasa seperti game.
- Gunakan komposisi Apple-native: rounded cards, generous spacing, hierarchy copy yang jelas.

## Implementation Order

### Task 1: App Shell and Navigation Skeleton

**Files:**
- Modify: `grounded/ContentView.swift`
- Create: `grounded/App/PactAppFlow.swift`
- Create: `grounded/App/PactRoute.swift`

- [x] Buat root flow yang menjadi driver demo seluruh app.
- [x] Definisikan route untuk `onboarding`, `contract`, `activeSession`, `replay`, dan `report`.
- [x] Sambungkan `ContentView` ke `PactAppFlow`.
- [x] Pastikan semua layar bisa dinavigasi dengan state dummy.

### Task 2: Design System Foundation

**Files:**
- Create: `grounded/DesignSystem/PactColors.swift`
- Create: `grounded/DesignSystem/PactSpacing.swift`
- Create: `grounded/DesignSystem/PactTypography.swift`
- Create: `grounded/DesignSystem/PactButtonStyle.swift`
- Create: `grounded/DesignSystem/PactCard.swift`
- Create: `grounded/Components/PactScreenContainer.swift`

- [x] Definisikan palet warna dasar untuk background, surface, accent, text primary, dan text secondary.
- [x] Definisikan spacing scale yang dipakai konsisten di seluruh screen.
- [x] Siapkan typography helper untuk headline, body, label, dan number emphasis.
- [x] Buat reusable card dan button style agar semua CTA terasa satu keluarga.
- [x] Bungkus layout screen dengan `PactScreenContainer` agar margin dan safe-area handling konsisten.

### Task 3: Mock UI Data

**Files:**
- Create: `grounded/Mocks/MockFocusContract.swift`
- Create: `grounded/Mocks/MockFocusSession.swift`
- Create: `grounded/Mocks/MockReplayData.swift`

- [x] Buat mock contract dengan task, duration, why it matters, consequence, dan tone.
- [x] Buat mock session dengan timer text, status text, focus stats, dan break stats.
- [x] Buat mock replay data untuk personal reminder dan consequence message.
- [x] Pastikan setiap screen punya preview data sendiri dan tidak saling tergantung secara rapuh.

### Task 4: Reusable Components

**Files:**
- Create: `grounded/Components/PactSectionHeader.swift`
- Create: `grounded/Components/PactTonePicker.swift`
- Create: `grounded/Components/PactMetricCard.swift`
- Create: `grounded/Components/PactPrimaryButton.swift`
- Create: `grounded/Components/PactSecondaryButton.swift`

- [x] Bangun `PactSectionHeader` untuk judul + supporting copy.
- [x] Bangun `PactTonePicker` dengan tiga opsi visual: `Supportive`, `Direct`, `Savage`.
- [x] Bangun `PactMetricCard` untuk angka report dan duration summary.
- [x] Bangun tombol CTA reusable agar layar tidak mengulang styling manual.

### Task 5: Onboarding Screen

**Files:**
- Create: `grounded/Screens/Onboarding/OnboardingView.swift`

- [x] Tampilkan headline yang menjelaskan inti produk secara singkat.
- [x] Tambahkan supporting text yang memperkenalkan konsep focus contract.
- [x] Tambahkan CTA utama menuju contract screen.
- [x] Pastikan layout tetap kuat tanpa ilustrasi eksternal.
- [x] Tambahkan preview untuk light/default state.

### Task 6: Create Focus Contract Screen

**Files:**
- Create: `grounded/Screens/Contract/CreateFocusContractView.swift`

- [x] Buat form visual untuk task title.
- [x] Buat input visual untuk duration.
- [x] Buat text area untuk `why it matters`.
- [x] Buat text area untuk `what is at stake`.
- [x] Integrasikan `PactTonePicker`.
- [x] Tambahkan CTA `Start Focus Session`.
- [x] Siapkan state visual untuk empty form dan filled form dengan mock data.

### Task 7: Active Focus Session Screen

**Files:**
- Create: `grounded/Screens/Session/ActiveFocusSessionView.swift`

- [x] Tampilkan timer besar sebagai anchor visual utama.
- [x] Tampilkan task title dan short reason.
- [x] Tampilkan status chip/label seperti `On Contract` atau `Focus Active`.
- [x] Tambahkan secondary section yang memberi rasa sesi sedang berjalan.
- [x] Siapkan preview untuk state `active` dan `paused visual`.

### Task 8: Break Alert Preview and Consequence Replay Screen

**Files:**
- Create: `grounded/Screens/Notification/BreakAlertPreviewView.swift`
- Create: `grounded/Screens/Replay/ConsequenceReplayView.swift`

- [x] Bangun preview kartu notifikasi yang menampilkan title dan body singkat.
- [x] Bangun Consequence Replay screen dengan fokus pada `break duration`.
- [x] Tampilkan reminder “why this matters” dan consequence line secara personal.
- [x] Tambahkan CTA `Resume Focus` dan `End Session`.
- [x] Pastikan hierarchy layar mendorong user kembali ke task, bukan sekadar membaca statistik.

### Task 9: Reflection Report Screen

**Files:**
- Create: `grounded/Screens/Report/ReflectionReportView.swift`

- [x] Tampilkan summary utama: focused time, lost time, break count.
- [x] Gunakan `PactMetricCard` untuk menyusun statistik.
- [x] Tambahkan session summary copy yang terasa reflektif tapi tetap ringkas.
- [x] Tambahkan CTA `Start New Session`.
- [x] Siapkan preview untuk sesi bagus dan sesi dengan banyak break.

### Task 10: Live Activity Visual Preview

**Files:**
- Create: `grounded/Screens/LiveActivity/LiveActivityPreviewView.swift`

- [x] Buat tampilan ringkas yang mensimulasikan informasi Live Activity.
- [x] Tampilkan task summary, timer, dan status.
- [x] Pastikan konten tetap terbaca dalam ruang sempit.
- [x] Gunakan ini sebagai referensi desain sebelum ActivityKit asli di milestone berikutnya.

### Task 11: End-to-End Demo Polish

**Files:**
- Modify: `grounded/App/PactAppFlow.swift`
- Modify: seluruh screen yang perlu penyesuaian copy/layout

- [x] Pastikan seluruh flow demo bisa diklik dari awal sampai akhir.
- [x] Audit konsistensi spacing, CTA labels, tone wording, dan visual hierarchy.
- [x] Rapikan preview-provider agar setiap layar bisa diinspeksi mandiri.
- [x] Pastikan tidak ada screen yang masih terlihat seperti placeholder generik.

## Suggested Build Sequence

1. Bangun app shell dan design system dulu supaya semua screen punya fondasi yang sama.
2. Buat mock models supaya tiap layar bisa langsung dipreview.
3. Bangun reusable components sebelum layar kompleks seperti form dan report.
4. Kerjakan screen berdasarkan flow user: onboarding -> contract -> active session -> replay -> report.
5. Tutup dengan preview notification/live activity dan polish demo flow.

## Definition of Done

- Semua file UI milestone 1 sudah ada dan terorganisir rapi.
- Semua screen punya SwiftUI preview yang jalan.
- User flow end-to-end bisa didemokan dari root app.
- Seluruh layar masih memakai mock state; belum ada logic persistence/lifecycle nyata.
- Visual sudah cukup matang untuk jadi dasar implementasi functionality berikutnya.

## Next Step After This Plan

Setelah dokumen ini disetujui, implementasi sebaiknya dimulai dari:

1. `Task 1: App Shell and Navigation Skeleton`
2. `Task 2: Design System Foundation`
3. `Task 3: Mock UI Data`

Tiga task ini akan membuka jalan supaya semua screen berikutnya bisa dibangun cepat dan konsisten.
