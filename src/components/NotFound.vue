<template>
  <div class="row pb-3 mb-2">
    <img id="not-found" src="/img/not-found.png" alt="404: Not Found">
    <p class="text-center text-primary font-weight-bold text-10 pt-4">
      Something Isn't Where It Should Be
    </p>
  </div>
</template>

<script>
export default {
  name: 'NotFound',
  props: {}
}
</script>

<style lang="css">
#not-found {
  max-height: 25em;
  max-width: 50em;
  margin: auto;
}
</style>
