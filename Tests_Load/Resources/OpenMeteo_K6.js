import http from 'k6/http';
import { check, sleep } from 'k6';

// --- DEFAULT CONFIG (może być nadpisana przez env vars) ---
const VUS = __ENV.VUS ? parseInt(__ENV.VUS) : 20;           // virtual users
const DURATION = __ENV.DURATION ? __ENV.DURATION : '5s';    // test length
const LAT = __ENV.LAT ? parseFloat(__ENV.LAT) : 60.17;
const LON = __ENV.LON ? parseFloat(__ENV.LON) : 24.94;

export const options = {
  vus: VUS,
  duration: DURATION,
  thresholds: {
    // ⏱️ czasy odpowiedzi
    http_req_duration: [
      'p(95)<500',    // 🟢 OK
      'p(99)<1200',   // 🟡 Warning
    ],
    // ❌ błędy
    http_req_failed: [
      'rate<0.01',    // 🟢 OK
      'rate<0.05',    // 🟡 Warning
    ],
  },
};


export default function () {
  const url = 'https://api.open-meteo.com/v1/forecast';
  const params = { latitude: LAT, longitude: LON, current_weather: true };
  const query = `?latitude=${params.latitude}&longitude=${params.longitude}&current_weather=${params.current_weather}`;
  
  const res = http.get(url + query);

  check(res, {
    'status is 200': (r) => r.status === 200,
    'body not empty': (r) => r.body && r.body.length > 0,
  });

  sleep(1); // mała przerwa
}