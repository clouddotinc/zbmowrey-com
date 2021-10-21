<template>
  <div role="main" class="main">
    <div class="container pt-5">
      <router-view></router-view>
      <Products />
    </div>
  </div>
</template>

<script>
import Products from "@/components/Products.vue"

export default {
  name: 'Body',
  components: { Products }
}
</script>