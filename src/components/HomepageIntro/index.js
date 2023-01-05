import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

const IntroList = [
  {
    title: 'Intro Shit Here',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
          My thoughts on technology and current events.
      </>
    ),
  },
  {
    title: 'Library',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
          Tutorials and guides for tech projects.
      </>
    ),
  },
  {
    title: 'Resume',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
          Hiring or recruiting? See here.
      </>
    ),
  },
];

function Intro({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageIntro() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {IntroList.map((props, idx) => (
            <Intro key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
