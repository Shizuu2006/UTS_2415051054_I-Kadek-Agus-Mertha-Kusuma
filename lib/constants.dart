enum CourseBackend { demo, api, supabase }

const courseBackend = CourseBackend.demo;
const studentName = 'I Kadek Agus Mertha Kusuma';
const studentNim = '2415051054';
const studentClass = 'PTI 5C';

const courseApiBaseUrl = 'https://mytugas-api.vercel.app';
const supabaseUrl = 'https://fwqtaffmohlxvzlryspg.supabase.co';
const supabasePublishableKey = 'sb_publishable_WiyH_FIPS4zF-ynfxzln1A_oHIpQAfi';
const supabaseCoursesTable = 'courses';
const statusPlanned = 'planned';
const statusActive = 'active';
const statusDone = 'done';
const statuses = [statusPlanned, statusActive, statusDone];

String normalizeStatus(String? status) {
  switch (status?.trim().toLowerCase()) {
    case 'active':
    case 'proses':
      return statusActive;
    case 'done':
    case 'selesai':
      return statusDone;
    case 'planned':
    case 'belum selesai':
      return statusPlanned;
    default:
      return statusPlanned;
  }
}

const appTitle = 'MY TUGAS';
