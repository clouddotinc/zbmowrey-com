import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

const ExperienceList = [
    {
        employer: "REP Sales",
        startYear: 2001,
        endYear: 2013,
        description: (<></>)
    }
]

const FeatureList = [
    {
        title: 'Blog',
        Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
        description: (
            <>
                My thoughts on technology and current events.
            </>
        ),
    },
    {
        title: 'Guides',
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

function Feature({Svg, title, description}) {
    return (
        <div className={clsx('col col--4')}>
            <div className="text--center">
                <Svg className={styles.featureSvg} role="img"/>
            </div>
            <div className="text--center padding-horiz--md">
                <h3>{title}</h3>
                <p>{description}</p>
            </div>
        </div>
    );
}

export default function HomepageFeatures() {
    return (
        <section className={styles.features}>
            <div className="container">
                <div className="row">
                    <div className={clsx('col col--12')}>
                        <h1>
                            Goals & Dreams
                        </h1>
                        My current role is really my dream role: as Principal Architect for Vega Cloud, I deliver both
                        software and cloud architectures to a team of bright, engaged engineers. My role and duties are
                        constantly in flux, adapting to the needs of the moment. I feel as if my work is impactful and
                        challenging. The position exposes me to a stream of new technologies, each of which must be
                        understood and evaluated.
                    </div>

                        <div className={clsx('col col--7')} style={{paddingTop: 2+'em'}}>
                        <h1>
                            Experience
                        </h1>
                        <h2>
                            Vega Cloud <a target="_blank" href="https://vegacloud.io"><small>🔗</small></a> (Spokane, WA), 2022-Present
                        </h2>
                        <h3>Principal Architect</h3>
                        <ul>
                            <li>Gather Business Requirements</li>
                            <li>Select Technologies & Design Patterns to Achieve Goals</li>
                            <li>Generate Diagrams & Specification Documents</li>
                            <li>Participate in Engineering Sprint Planning Sessions</li>
                            <li>Support All Teams' Architecture Needs</li>
                            <li>Evaluate New Technologies</li>
                        </ul>


                        <h2 style={{paddingTop: 2+'em'}}>
                            2nd Watch <a target="_blank" href="https://2ndwatch.com"><small>🔗</small></a> (Spokane, WA), 2021-2022 (19 mo)
                        </h2>
                        <h3>Technical Advisor, FinOps</h3>
                        <ul>
                            <li>Create and maintain best-practices documentation</li>
                            <li>Provide support and guidance to a team of FinOps analysts & data engineers</li>
                            <li>Research new cloud offerings and identify optimization strategies</li>
                            <li>Communicate with client executive teams</li>
                        </ul>
                        <h3>
                            Cloud Consultant
                        </h3>
                        <ul>
                            <li>Worked with F100 Companies to Migrate On-Prem Datacenters to AWS.</li>
                            <li>Coordinate stakeholder meetings & application discovery sessions.</li>
                            <li>Compile extensive app documentation: resource lists, schedules, go/no-go points, etc.</li>
                            <li>Evaluate and address push-back from app teams, presenting solutions.</li>
                        </ul>


                        <h2 style={{paddingTop: 2+'em'}}>
                            ShineOn.com <a target="_blank" href="https://shineon.com"><small>🔗</small></a> (St. Petersburg, FL) 2021-2021 (6 mo)
                        </h2>
                        <h3>Senior Software Engineer</h3>
                        <ul>
                            <li>Laravel & VueJS E-Commerce Management App (Shopify Integration)</li>
                            <li>Deliver new app features</li>
                            <li>Troubleshoot and Resolve reported bugs</li>
                            <li>Refine, Tune, and Extend AWS Infrastructure Management</li>
                        </ul>


                        <h2 style={{paddingTop: 2+'em'}}>
                            Chargebacks911 <a target="_blank" href="https://chargebacks911.com"><small>🔗</small></a> (Clearwater, FL) 2018-2020 (24 mo)
                        </h2>
                        <h3>Software Development Manager</h3>
                        <ul>
                            <li>Lead an engineering team in delivery of multiple applications:
                                <ul>
                                    <li>Client-Facing REST API</li>
                                    <li>Core Line-of-Business Management App</li>
                                    <li>Document Preparation Microservice</li>
                                    <li>Document Transport Microservice</li>
                                    <li>Financial Reports Microservice</li>
                                </ul>
                            </li>
                            <li>
                                Work with a dedicated infrastructure team to deliver self-service/IAC for my apps.
                            </li>
                            <li>Participate in senior leadership strategy meetings, GAP analysis, and sprint planning.</li>
                            <li>Liase with project management to gather requirements and definition-of-done specifications.</li>
                            <li>
                                Train and evaluate team members in policy & regulatory compliance (GDPR, PCI).
                            </li>
                            <li>
                                Collaborate with IT and external vendors to respond to audit documentation requests,
                                respond to penetration test reports, etc.
                            </li>
                        </ul>


                        <h2 style={{paddingTop: 2+'em'}}>
                            AffTrack.com <a target="_blank" href="http://afftrack.com/"><small>🔗</small></a> (Spring Hill, FL) 2015-2018 (3.5 yr)
                        </h2>
                        <h3>Software Engineer</h3>
                        <ul>
                            <li>Deliver new feature & bug support to a legacy PHP application.</li>
                            <li>Provide front-line ticket support for client issues.</li>
                            <li>Install & configure servers in data center environments.</li>
                            <li>Participate in trade shows & conferences as sales support.</li>
                        </ul>

                        <h2 style={{paddingTop: 2+'em'}}>
                            Computer Centers USA (Defunct) (Tampa, FL) 2014-2015 (1 yr)
                        </h2>
                        <h3>Floor Manager</h3>
                        <ul>
                            <li>Supervise 50+ Personnel
                                <ul>
                                    <li>Set schedules</li>
                                    <li>Monitor performance</li>
                                    <li>Enforce policy</li>
                                    <li>Handle personal issues</li>
                                </ul>
                            </li>
                            <li>
                                Act as escalation support for:
                                <ul>
                                    <li>Difficult clients</li>
                                    <li>Technically challenging issues</li>
                                </ul>
                            </li>
                            <li>Respond to QA feedback and resolve open issues.</li>
                            <li>
                                Create documentation & applications in support of:
                                <ul>
                                    <li>Improving Quality Scores</li>
                                    <li>Improving Case Velocity</li>
                                    <li>Improving Troubleshooting Consistency</li>
                                </ul>
                            </li>
                        </ul>

                        <h2 style={{paddingTop: 2+'em'}}>
                            REP Sales <a target="_blank" href="https://repsales.net/"><small>🔗</small></a> (Olney, IL) 2001-2013 (13 yr)
                        </h2>
                        <h3>Vice President</h3>
                        <ul>
                            <li>
                                Rose through the ranks and accumulated skill in many business roles:
                                <ul>
                                    <li>IT</li>
                                    <li>Leadership</li>
                                    <li>Sales</li>
                                    <li>Purchasing</li>
                                    <li>Warehousing</li>
                                </ul>
                            </li>
                            <li>Helpdesk Support for All Tech Issues.</li>
                            <li>Build/Maintain Servers (Exchange, BES, Terminal Server)</li>
                            <li>Build/Maintain Multi-Site VPN (Remote Access, Remote Printing)</li>
                            <li>Build/Maintain Network Including WAN Failover</li>
                            <li>Manage Offsite Tape Backups</li>
                        </ul>
                        </div>
                        <div className={clsx('col col--5')} style={{paddingTop: 2+'em'}}>
                            <h1>
                                Education
                            </h1>
                            <h2>
                                BS Cloud Computing, WGU 2020-2023
                            </h2>
                            <h1>
                                Certifications (<a target="_blank" href="https://www.credly.com/users/zachary-mowrey/badges"><small>🔗</small></a>)
                            </h1>
                            <ul>
                                <li>AWS Solutions Architect Professional</li>
                                <li>AWS Solutions Architect Associate</li>
                                <li>AWS SysOps Administrator Associate</li>
                                <li>AWS Cloud Practitioner</li>
                                <li>FinOps Practitioner</li>
                                <li>Terraform Associate</li>
                                <li>HashiCorp Implementation Partner</li>
                                <li>CompTia A+</li>
                                <li>CompTia Network+</li>
                                <li>CompTia Security+</li>
                                <li>CompTia Cloud+</li>
                                <li>CompTia Project+</li>
                                <li>LPI Linux Essentials</li>
                                <li>AWS Partner Accreditation: Technical</li>
                                <li>AWS Partner Accreditation: Business</li>
                                <li>AWS Partner Accreditation: Economics</li>
                            </ul>
                            <h1>
                                Technologies
                            </h1>
                            <ul>
                                <li>
                                    Cloud Computing
                                    <ul>
                                        <li>AWS</li>
                                        <li>Azure</li>
                                        <li>GCP</li>
                                    </ul>
                                </li>
                                <li>
                                    Programming Languages
                                    <ul>
                                        <li>PHP</li>
                                        <li>VueJS</li>
                                        <li>Node</li>
                                        <li>Python</li>
                                        <li>SQL</li>
                                        <li>Bash</li>
                                        <li>HTML/CSS/Sass</li>
                                    </ul>
                                </li>
                                <li>Containers
                                    <ul>
                                        <li>Docker Compose</li>
                                        <li>ECS Fargate</li>
                                        <li>Lambda</li>
                                    </ul>
                                </li>
                                <li>Operating Systems
                                    <ul>
                                        <li>Linux (Ubuntu, RHEL, Amazon)</li>
                                        <li>Windows Desktop</li>
                                        <li>Windows Server</li>
                                    </ul>
                                </li>
                                <li>
                                    DevOps / IAC
                                    <ul>
                                        <li>Terraform</li>
                                        <li>CloudFormation</li>
                                        <li>Github Actions</li>
                                        <li>Gitlab CI</li>
                                    </ul>
                                </li>
                                <li>
                                    IDEs
                                    <ul>
                                        <li>PHPStorm</li>
                                        <li>PyCharm</li>
                                        <li>WebStorm</li>
                                        <li>DataGrip</li>
                                    </ul>

                                </li>
                            </ul>
                        </div>
                </div>
            </div>
        </section>
    );
}
