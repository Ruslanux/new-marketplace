import { Controller } from "@hotwired/stimulus"
// Import Swiper from the pinned bundle in importmap.rb
import Swiper from 'swiper/bundle'

// Connects to data-controller="gallery"
export default class extends Controller {
  connect() {
    // Initialize the thumbnail gallery
    const thumbsSwiper = new Swiper(this.element.querySelector('.thumbs-swiper'), {
      spaceBetween: 10,
      slidesPerView: 4,
      freeMode: true,
      watchSlidesProgress: true,
    });

    // Initialize the main image gallery
    const mainSwiper = new Swiper(this.element.querySelector('.main-swiper'), {
      // Register the modules from the bundle
      modules: [Swiper.Navigation, Swiper.Thumbs],
      spaceBetween: 10,
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      thumbs: {
        swiper: thumbsSwiper,
      },
    });
  }
}
