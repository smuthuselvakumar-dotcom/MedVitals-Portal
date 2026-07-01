/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Tenant dynamic colors-க்கு ஏதுவாகப் பின்னாளில் மாற்றிக்கொள்ளலாம்
        tenantPrimary: 'var(--primary-color)',
        tenantSecondary: 'var(--secondary-color)',
      }
    },
  },
  plugins: [],
}