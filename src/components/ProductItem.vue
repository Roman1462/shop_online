<template>
    <li class="catalog__item">
        <router-link class="catalog__pic" :to="{name:'product',params:{id:item.id}}">
          <img
            :src="item.image"            
            :alt="item.title"
          />
        </router-link>

        <h3 class="catalog__title">
          <a href="#">{{ item.title }}</a>
        </h3>

        <span class="catalog__price"> {{ item.price | numberFormat }} ₽ </span>

        <ul class="colors colors--black">
          <li class="colors__item" v-for="c in item.colors" :key="c.id">
            <label class="colors__label">
              <input
                class="colors__radio sr-only"
                type="radio"
                :value="c.code"                 
              />
              <span class="colors__value" :style="'background-color: '+c.code">
              </span>
            </label>
          </li>          
        </ul>
      </li>
</template>

<script>
// import colors from "../data/colors.js"
import gotoPage from "@/helpers/gotoPage.js"
import numberFormat from "@/helpers/numberFormat.js"

export default {
  filters:{
    numberFormat
  },
  methods: {
    gotoPage
  },  
  props:['item','index']
}
</script>
