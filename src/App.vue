<template>
  <div id="app" class="body">
    <Body />
  </div>
</template>

<script>

import Body from "@/components/structure/Body.vue";

export default {
  name: 'App',
  created() {
    document.title = "Technical Advisor, Cloud Economics"
  },
  components: {Body}
}
</script>

<style></style>

