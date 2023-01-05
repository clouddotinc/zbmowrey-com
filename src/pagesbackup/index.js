import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';

import styles from './index.module.css';
import HomepageIntro from "../components/HomepageIntro";

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">
            About Me
        </h1>
        <div className="row">
            <div className={clsx('col col--3')} style={{paddingTop: 2+'em'}}>
                <img src="/img/zach-round.png" style={{maxHeight: 15+'em'}}></img>
            </div>
            <div className={clsx('col col--9')} style={{paddingTop: 2+'em'}}>
                <p className="hero__subtitle text--left" style={{paddingTop: 1 + 'em'}}>
                    I'm a technology enthusiast with more than 20 years' experience in the field. As a Cloud Software Architect,
                    I gather requirements from business leaders and translate those into the arcane symbols required by Engineers.
                    My interests and hobbies are mostly tech-focused, but I also enjoy traveling with my family and pointing out that
                    it's not cold in Florida.
                </p>
            </div>
        </div>

        {/*<div className={styles.buttons}>*/}
        {/*  <Link*/}
        {/*    className="button button--secondary button--lg"*/}
        {/*    to="/docs/intro">*/}
        {/*    Docusaurus Tutorial - 5min ⏱️*/}
        {/*  </Link>*/}
        {/*</div>*/}
      </div>
    </header>
  );
}

export default function Home() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={`Zach Mowrey`}
      description="Description will go into a meta tag in <head />">
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}
