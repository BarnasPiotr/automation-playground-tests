
# Automation Playground Tests
![CI](https://github.com/BarnasPiotr/automation-playground-tests/actions/workflows/run_robot.yml/badge.svg)

Unified QA automation framework for Web, API, Mobile, and Load testing built with Robot Framework (Browser Library - Playwright), Appium, and integrated with CI/CD.

## 📁 Structure
```bash
automation-playground-tests/
├── Tests_Web/
├── Tests_API/
├── Tests_Mobile/
├── Tests_Load/
├── .github/workflows/
├── requirements.txt
└── run_all_tests.sh
```



## 🧪 Test Areas

- Web → Robot Framework + Browser (Playwright)
- API → Robot Framework + Requests + JSONLibrary
- Mobile → Robot Framework + AppiumLibrary
- Load → Robot Framework + k6


## Run locally

```bash
pip install -r requirements.txt
rfbrowser init
```


### Run tests
```bash
robot Tests_Web/Tests
robot Tests_API/Tests
robot Tests_Mobile/Tests
robot Tests_Load/Tests
```

## CI/CD
```md
GitHub Actions runs Web and API tests automatically on every push.
```

## 👤 Author

Piotr Barnas
