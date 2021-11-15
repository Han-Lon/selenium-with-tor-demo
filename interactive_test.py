from tbselenium.tbdriver import TorBrowserDriver
from tbselenium.utils import start_xvfb, stop_xvfb
import pathlib

project_filepath = pathlib.Path(__file__).parent.absolute()


def fill_form(driver, id, value=None):
    if id == "submit":
        element = driver.find_element_by_css_selector("[type='submit']")
        element.click()
    else:
        element = driver.find_element_by_id(id)
        element.send_keys(value)


def visit_site(url, name):
    # Start xvfb to handle virtual display
    xvfb_display = start_xvfb()
    pref_dict = {"permissions.default.image": 2,
                 "extensions.torbutton.loglevel": 5}  # Don't load images and set Torbutton log level to WARN
    with TorBrowserDriver(str(project_filepath / "tor-browser_en-US"),
                          pref_dict=pref_dict,
                          executable_path=str(project_filepath / "geckodriver")) as driver:
            out_img = str(project_filepath / "test.png")
            driver.load_url(url)
            fill_form(driver, "name", name)
            fill_form(driver, "submit")
            driver.get_screenshot_as_file(out_img)
            print("Screenshot is saved as %s" % out_img)
    stop_xvfb(xvfb_display)


if __name__ == "__main__":
    website_url = input("Enter a website URL to visit with TOR: ")
    input_name = input("Enter a random name: ")
    visit_site(website_url, input_name)