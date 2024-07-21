import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="urls"
export default class extends Controller {
  static targets = ["urlsTable", "successMessage", "input", "errorMessage"]

  connect() {
    console.log("UrlsController connected", new Date());
  }

  validateAndSubmit(event) {
    event.preventDefault();
  
    const urlInput = this.inputTarget.value.trim();
    const urlPattern = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
  
    if (urlInput === "") {
      this.showErrorMessage("URL cannot be empty");
      return;
    }
  
    if (!urlPattern.test(urlInput)) {
      this.showErrorMessage("Please enter a valid URL");
      return;
    }
  
    // If input is valid, submit the form
    this.element.submit();
  }

  showErrorMessage(message) {
    this.errorMessageTarget.innerText = message;
    this.errorMessageTarget.style.display = "block";
  }

  hideErrorMessage() {
    this.errorMessageTarget.style.display = "none";
  }
}
