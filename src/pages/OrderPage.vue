<template>
    <PreloaderBig v-if="loading" />
    <main class="content container" v-else>
    <div class="content__top">
      <ul class="breadcrumbs">
        <li class="breadcrumbs__item">
          <a class="breadcrumbs__link" href="index.html">
            Каталог
          </a>
        </li>
        <li class="breadcrumbs__item">
          <a class="breadcrumbs__link" href="cart.html">
            Корзина
          </a>
        </li>
        <li class="breadcrumbs__item">
          <a class="breadcrumbs__link">
            Оформление заказа
          </a>
        </li>
      </ul>

      <h1 class="content__title">
        Корзина
      </h1>
      <span class="content__info">
        3 товара
      </span>
    </div>

    <section class="cart">
      <form class="cart__form form" action="#" method="POST" @submit.prevent="order">
        <div class="cart__field">
          <div class="cart__data">
            <BaseFormText title="ФИО" placeholder="Введите ваше полное имя" v-model="formData.name" :error="formError.name"/>            
            <BaseFormText title="Адрес доставки" placeholder="Введите ваш адрес" v-model="formData.address" :error="formError.address"/>            
            <BaseFormText title="Телефон" placeholder="Введите ваш телефон" v-model="formData.phone" :error="formError.phone" type="tel"/>            
            <BaseFormText title="Email" placeholder="Введи ваш Email" v-model="formData.email" :error="formError.email" type="email"/>            
            <BaseFormTextarea title="Комментарий к заказу" placeholder="Ваши пожелания" v-model="formData.comment" :error="formError.comment"/>
          </div>

          <div class="cart__options">
            <h3 class="cart__title">Доставка</h3>
            <ul class="cart__options options">
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="delivery" value="0" checked="">
                  <span class="options__value">
                    Самовывоз <b>бесплатно</b>
                  </span>
                </label>
              </li>
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="delivery" value="500">
                  <span class="options__value">
                    Курьером <b>500 ₽</b>
                  </span>
                </label>
              </li>
            </ul>

            <h3 class="cart__title">Оплата</h3>
            <ul class="cart__options options">
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="pay" value="card">
                  <span class="options__value">
                    Картой при получении
                  </span>
                </label>
              </li>
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="pay" value="cash">
                  <span class="options__value">
                    Наличными при получении
                  </span>
                </label>
              </li>
            </ul>
          </div>
        </div>

        <div class="cart__block">
          <OrderList :cartProducts="cartProducts" :totalPrice="totalPrice" />
          <button class="cart__button button button--primery" type="submit">
            Оформить заказ
          </button>
        </div>
        <div class="cart__error form__error-block" v-if="formErrorMessage">
          <h4>Заявка не отправлена!</h4>
          <p>
            {{ formErrorMessage }}
          </p>
        </div>
      </form>
    </section>
  </main>
</template>

<script>
import BaseFormText from "@/components/BaseFormText.vue"
import BaseFormTextarea from "@/components/BaseFormTextarea.vue"
import OrderList from "@/components/OrderList.vue";
import PreloaderBig from "@/components/PreloaderBig.vue";
import { mapGetters } from "vuex";
import axios from 'axios'
import { API_BASE_URL } from "@/config"

export default {
    components:{ BaseFormText, BaseFormTextarea, OrderList, PreloaderBig },
    computed: {
      ...mapGetters({
      totalPrice: "cartTotalPrice",
      cartProducts: "cartProducts",      
    })
    },

    data(){
        return{
            formData:{},
            formError:{},
            formErrorMessage:'',
            loading:false
        }
    },
    methods:
    {   
        order(){
            this.formError = {};
            this.formErrorMessage = ''
            this.loading=true;
            axios
                .post(API_BASE_URL + 'api/orders',{
                    ...this.formData
                    },
                        {
                        params:{
                            userAccessKey:this.$store.state.userAccesKey
                        }
                    }
                )
                .then(response => {
                    this.$store.commit('resetCart');
                    this.$store.commit('updateOrderInfo', response.data);
                    this.$router.push({name:'orderInfo', params:{id:response.data.id}});
                    this.loading=false;
                })
                .catch(error => {
                    this.formErrorMessage = error.response.data.error.message;
                    this.formError = error.response.data.error.request || {}
                    this.loading=false;
                })

        }
    }

}
</script>
