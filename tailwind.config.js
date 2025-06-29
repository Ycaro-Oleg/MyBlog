module.exports = {
  darkMode: 'class',
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.css',
    './TEST_DARK_MODE.html'
  ],
  theme: {
    extend: {
      colors: {
        beige: {
          50: '#fdfaf6',
          100: '#f8f3ed',
          200: '#f1e7db',
          300: '#e9dac9',
          400: '#e0ceb7',
          500: '#d6c2a5',
          600: '#c2ae93',
          700: '#ad9a81',
          800: '#99866f',
          900: '#84725d',
        },
      }
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}