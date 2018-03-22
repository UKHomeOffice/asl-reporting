
const puppeteer = require('puppeteer');

async function run() {
	  const browser = await puppeteer.launch();
	  const page = await browser.newPage();

	  var program_name = process.argv[0]; 
	  var script_path = process.argv[1]; 
	  var username = process.argv[2]; 
	  var password = process.argv[3];
	  var url = "https://jira.digital.homeoffice.gov.uk/issues/?jql=project%20%3D%20%22Animal%20Sciences%22%20and%20Sprint%20in%20openSprints()";
	  
	  await page.goto('https://jira.digital.homeoffice.gov.uk/login.jsp');
	  const USERNAME_SELECTOR = '#login-form-username';
	  const PASSWORD_SELECTOR = '#login-form-password';
	  const BUTTON_SELECTOR = '#login-form-submit';
	  await page.click(USERNAME_SELECTOR);
	  await page.keyboard.type(username);

	  await page.click(PASSWORD_SELECTOR);
	  await page.keyboard.type(password);

	  await page.click(BUTTON_SELECTOR);
          await page.waitForNavigation();

	  await page.goto(url);
	  await page.waitFor(2*1000);

	  await page.screenshot({ path: 'screenshots/url.png', fullPage:true });
	  browser.close();
}

run();
