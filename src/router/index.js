import Vue from "vue";
import VueRouter from "vue-router";

import About from "../components/About.vue";
import Blog from "../components/Blog.vue";
import Resume from "../components/Resume.vue";
import NotFound from "../components/NotFound.vue";
import DevOps from "../components/DevOps";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "About",
    component: About,
  },
  {
    path: "/devops",
    name: "DevOps",
    component: DevOps,
  },
  {
    path: "/blog",
    name: "Blog",
    component: Blog
  },
  {
    path: "/resume",
    name: "Resume",
    component: Resume,
  },
  {
    path: "*",
    name: "NotFound",
    component: NotFound,
  },
];

const router = new VueRouter({
  routes,
  mode: 'history'
});

export default router;
